defmodule MarkdownWeb.Mark.Index do
  use MarkdownWeb, :live_view

  defp global_path do "lib/markdown_web/files/" end

  def getFile(file) do
    path = Enum.join([global_path(), file], "")
    File.read(path)
  end
end
