defmodule DiscussWeb.AuthByPwdController do
  use DiscussWeb, :controller
  alias Discuss.Model.User
  alias Discuss.Repo
  import Ecto.Query, warn: false
  alias Discuss.Repo

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def signUpByPw(conn, %{"user" =>  %{"email" => email, "pwd"=> pwd, "password_confirm" => password_confirm}}) do
    if(pwd != password_confirm) do
      conn |> put_flash(:error, "Confirm password not match") |> redirect(to: Routes.auth_by_pwd_path(conn, :new))
    else
      # render(conn, Routes.topic_path("index.html"))
      case isDuplicateEmail(email) do
        {:ok} ->
          password = Argon2.hash_pwd_salt(pwd)
          change= %{"email" => email, "password" => password}
          case User.changeset(%User{}, change) |> Repo.insert() do
            {:ok, struct} ->
               conn |> put_flash(:info, "Register successfully !") |> put_session(:user_id, struct.id) |> redirect(to: Routes.topic_path(conn, :index))
            {:error, changeset} ->
              conn
              |> put_flash(:error, "Error signin in, please try again !")
              |> redirect(to: Routes.topic_path(conn, :index))
          end
        {:error} ->
          conn |> put_flash(:error, "Email is used, please use other email") |> redirect(to: Routes.auth_by_pwd_path(conn, :new))
      end
    end
  end

  def login(conn, _paramms) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "login.html", changeset: changeset)
  end

  def signInByPw(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)
    IO.inspect(user.password)
    if(user == nil) do
      conn |> put_flash(:error, "Email not found!") |> redirect(to: Routes.auth_by_pwd_path(conn, :login))
    else
         case Argon2.verify_pass(password, user.password) do
            true ->
              conn |> put_flash(:info, "Login successfully !") |> put_session(:user_id, user.id) |> redirect(to: Routes.topic_path(conn, :index))
            false ->
              conn |> put_flash(:error, "Password incorrect!") |> redirect(to: Routes.auth_by_pwd_path(conn, :login))
         end
    end
  end

  defp isDuplicateEmail(email) do
    case Repo.get_by(User, email: email ) do
      nil ->
        {:ok}
      user ->
        {:error}
    end
  end
end
