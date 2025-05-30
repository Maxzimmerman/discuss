defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    IO.inspect(conn.assigns)
    topics = Repo.all(Topic)
    render(conn, :index, topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Discuss.Topic{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: ~p"/")
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render(conn, :edit, changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic}) do
    old_topic = Repo.get(Topic, id)
    changeset = Topic.changeset(old_topic, topic)
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: ~p"/")
      {:error, changeset} ->
        render(conn, :edit, changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id) |> Repo.delete!()
    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: ~p"/")
  end
end
