defmodule Discuss.Model.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:email]}

  schema "users" do
    field(:email, :string)
    field(:provider, :string)
    field(:token, :string)
    field :password, :string
    field :pwd, :string, virtual: true
    field :password_confirm, :string, virtual: true
    has_many :topics, Discuss.Model.Topic
    has_many :comments, Discuss.Model.Comment

    # timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :token, :password, :provider])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
