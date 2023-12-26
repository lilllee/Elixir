defmodule MarkdownWeb.Mark.Index do
  use MarkdownWeb, :live_view

  defp global_path do "lib/markdown_web/files/" end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      MarkdownWeb.Endpoint.subscribe("post")
    end
    {:ok, assign(socket, markdown: markdown(), topic: "post")}
  end

  def getFile(file) do
    path = Enum.join([global_path(), file], "")
    File.read(path)
  end

  def markdown do

    path = Enum.join([global_path(), "test.md"], "")
    text = File.read!(path)

    String.trim(text)
      |> Earmark.as_html!(code_class_prefix: "lang- language-")
      |> Phoenix.HTML.raw()
  end

end
