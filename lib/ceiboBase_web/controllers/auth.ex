defmodule CeiboBaseWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias CeiboBaseWeb.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(CeiboBase.Accounts.User, user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> CeiboBase.Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
    # |> put_session(:user_id, user.id)
    # |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> CeiboBase.Guardian.Plug.sign_out()
  end

  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(CeiboBase.Accounts.User, username: username)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true  ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
