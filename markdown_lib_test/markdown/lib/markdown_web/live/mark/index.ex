defmodule MarkdownWeb.Mark.Index do
  use MarkdownWeb, :live_view

  defp global_path do "lib/markdown_web/files/" end
  defp category_path do "lib/markdown_web/categories" end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      MarkdownWeb.Endpoint.subscribe("post")
    end
    {:ok, assign(socket, markdown: markdown("lib/markdown_web/files/test.md"),
     topic: "post",
     fileList: file_list(),
     categoies: categories()
     )
    }
  end

  def markdown(mdF) do
    text = File.read!(mdF)
    String.trim(text)
      |> Earmark.as_html!(code_class_prefix: "lang- language-")
      |> Phoenix.HTML.raw()
  end

  def current_files do
    path = Enum.join([global_path(), "*.md"], "")
    Enum.count(Path.wildcard(path))
  end

  def handle_event("mdClick", %{"filename" => val1, "category" => val2}, socket) do
    {:noreply, update_markdown(val1, val2, socket)}
  end

  defp update_markdown(file_name, category, socket) do

    path = if file_name === "home" do
      "lib/markdown_web/files/test.md"
    else
      Enum.join([category_path(), category, file_name], "/")
    end

    html_content = markdown(path)
    assign(socket, :markdown, html_content)
  end

  def file_list do
    files = Path.wildcard("lib/markdown_web/files/*.md")
    Enum.map(files, fn path ->
      String.replace(path, global_path(), "")
    end
    )

  end

  def categories do
    files = Path.wildcard("lib/markdown_web/categories/*")

    cates = Enum.map(files, fn path ->
      String.replace(path, Enum.join([category_path(),"/"]), "")
    end)

    Enum.reduce(cates, %{}, fn cate, acc ->
      mdfiles = Path.wildcard("lib/markdown_web/categories/#{cate}/*.md")

      replace_files = Enum.map(mdfiles, fn path ->
        String.replace(path, "lib/markdown_web/categories/#{cate}/", "")
      end)

      Map.put(acc, cate, replace_files)
    end)

  end
end
