defmodule LiveViewTodosWeb.TodoLive do
  require Logger
  use Phoenix.LiveView
  alias LiveViewTodos.Todos
  alias LiveViewTodosWeb.TodoView

  def mount(_session, socket) do
    Todos.subscribe()

    {:ok, assign(socket, todos: Todos.list_todos())}
  end

  def render(assigns) do
    TodoView.render("todos.html", assigns)
    # ~L"Rendering LiveView"
  end

  def handle_event("add", %{"todo" => todo}, socket) do
    Logger.debug("in handle_event...")
    todo |> inspect() |> Logger.debug()

    Todos.create_todo(todo)

    {:noreply, fetch(socket)}
  end

  def handle_event("toggle_done", id, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})
    {:noreply, socket}
  end

  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, todos: Todos.list_todos())
  end
end
