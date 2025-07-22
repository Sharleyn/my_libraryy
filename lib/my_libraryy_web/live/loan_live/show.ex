defmodule MyLibraryyWeb.LoanLive.Show do
  use MyLibraryyWeb, :live_view

  alias MyLibraryy.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:loan, Library.get_loan!(id))}
  end

  defp page_title(:show), do: "Show Loan"
  defp page_title(:edit), do: "Edit Loan"
end
