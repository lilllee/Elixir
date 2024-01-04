defmodule MarkdownWeb.Mark.Index do
  use MarkdownWeb, :live_view

  defp global_path do "lib/markdown_web/files/" end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      MarkdownWeb.Endpoint.subscribe("post")
    end
    {:ok, assign(socket, markdown: markdown("test.md"),
     topic: "post",
     fileList: file_list(),
     count: current_files())
    }
  end

  def getFile(file) do
    path = Enum.join([global_path(), file], "")
    File.read(path)
  end

  def markdown(mdF) do

    path = Enum.join([global_path(), mdF], "")
    text = File.read!(path)

    String.trim(text)
      |> Earmark.as_html!(code_class_prefix: "lang- language-")
      |> Phoenix.HTML.raw()
  end

  def current_files do
    path = Enum.join([global_path(), "*.md"], "")
    Enum.count(Path.wildcard(path))
  end

  def handle_event("mdClick", %{"filename" => val1}, socket) do
    {:noreply, update_markdown(val1, socket)}
  end

  defp update_markdown(file_name, socket) do
    html_content = markdown(file_name)
    assign(socket, :markdown, html_content)
  end


  def file_list do
    files = Path.wildcard("lib/markdown_web/files/*.md")
    Enum.map(files, fn path ->
      String.replace(path, global_path(), "")
    end
  )

  end

end
