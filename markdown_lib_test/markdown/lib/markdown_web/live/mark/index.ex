defmodule MarkdownWeb.Mark.Index do
  use MarkdownWeb, :live_view

  def parse_markdown(markdown) do
    EarmarkParser.to_html
  end
end
