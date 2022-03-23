defmodule Discuss.Model.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content, :user]}

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.Model.User
    belongs_to :topic, Discuss.Model.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct |> cast(params, [:content]) |> validate_required([:content])
  end
end
