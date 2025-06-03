defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.{Topic, Repo, Comment}

  def join("comments:" <> topic_id, _params, socket) do
    # query the topic with all belonging comments
    topic_id = String.to_integer(topic_id)
    # we get all users of comments that belong to the current topic
    topic =
      Topic
      |> Repo.get(topic_id)
      |> Repo.preload(comments: [:user])

    # return the comments and add the topic to the socket to the handle method can work with it
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    # add a new comment to the current topic
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset =
      topic
      |> Ecto.build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    # insert new comment for current topic
    case Repo.insert(changeset) do
      {:ok, comment} ->
        # the broadcast method send the data to all subscribers so
        # the new socket is displayed in real time for all subscribers
        broadcast!(
          socket,
          "comments:#{socket.assigns.topic.id}:new",
          %{comment: comment}
        )

        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

    {:reply, :ok, socket}
  end
end
