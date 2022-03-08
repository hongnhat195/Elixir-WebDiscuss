defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  import Ecto.Query, warn: false
  alias Discuss.Repo
  alias Discuss.Model
  alias Discuss.Model.Topic

  plug(DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :update, :delete])

  def index(conn, _params) do
    topics = Model.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Model.change_topic(%Topic{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    # method 1
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic_params)

    case Repo.insert(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: Routes.topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end

    #  method 2
    # changeset =
    #   conn.assigns.user
    #   |> Ecto.build_assoc(:topics)

    # change = Map.put(topic_params, "user_id", changeset.user_id)

    # case Model.create_topic(change) do
    #   {:ok, topic} ->
    #     conn
    #     |> put_flash(:info, "Topic created successfully.")
    #     |> redirect(to: Routes.topic_path(conn, :show, topic))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    topic = Model.get_topic!(id)
    render(conn, "show.html", topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    # IO.inspect(conn)
    topic = Model.get_topic!(id)
    changeset = Model.change_topic(topic)
    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Model.get_topic!(id)

    case Model.update_topic(topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: Routes.topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Model.get_topic!(id)
    {:ok, _topic} = Model.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
