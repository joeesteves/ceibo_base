defmodule Mix.Tasks.Tr do
  use Mix.Task

  @shortdoc "Automates gettext"
  def run(_) do
    Mix.Task.run("gettext.extract")
    Mix.Task.run("gettext.merge", ["priv/gettext","--locale", "es"])
  end
end
