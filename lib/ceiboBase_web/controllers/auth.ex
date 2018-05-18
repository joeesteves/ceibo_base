defmodule CeiboBaseWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias CeiboBaseWeb.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(CeiboBase.Accounts.User, user_id)
    assign(conn, :current_user, user)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Area Restringida")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
end
