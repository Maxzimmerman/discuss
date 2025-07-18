defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.User
  alias Discuss.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed: #{hd(failure.errors).message}")
    |> redirect(to: ~p"/")
  end

  def login(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, :login, changeset: changeset)
  end

  def log_user_in(conn, %{"user" => user}) do
    changeset = User.changeset(%User{}, user)
    signin(conn, changeset)
  end

  def signup(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, :signup, changeset: changeset)
  end

  def create_user(conn, %{"user" => user}) do
    changeset = User.email_changeset(%User{}, user)
    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back! #{user.email}")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: ~p"/")
    end
  end

  defp insert_or_update_user(changeset) do
     case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
     end
  end
end
