defmodule MyLibraryyWeb.AdminSettingsLive do
  use MyLibraryyWeb, :live_view

  alias MyLibraryy.Administration

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account email address and password settings</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.input field={@email_form[:email]} type="email" label="Email" required />
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Current password"
            value={@email_form_current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Email</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/admins/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_admin_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>


      <div>
        <h3 class="text-lg font-medium leading-6 text-gray-900 mb-4">Profile Information</h3>
        <.simple_form
          for={@profile_form}
          id="profile_form"
          phx-submit="update_profile"
          phx-change="validate_profile"
        >
          <.input field={@profile_form[:full_name]} type="text" label="Full Name" required />
          <.input
            field={@profile_form[:ic]}
            type="text"
            label="IC Number"
            placeholder="123456789012"
            required
          />
          <.input
            field={@profile_form[:status]}
            type="select"
            label="Status"
            options={[{"Active", "active"}, {"Inactive", "inactive"}, {"Pending", "pending"}]}
            required
          />
          <.input
            field={@profile_form[:phone]}
            type="text"
            label="Phone Number"
            placeholder="+60123456789"
          />
          <.input field={@profile_form[:date_of_birth]} type="date" label="Date of Birth" />
          <.input field={@profile_form[:address]} type="textarea" label="Address" rows="3" />
          <:actions>
            <.button phx-disable-with="Saving...">
              {if @current_profile, do: "Update Profile", else: "Create Profile"}
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Administration.update_admin_email(socket.assigns.current_admin, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/admins/settings")}
  end

  def mount(_params, _session, socket) do
    admin = socket.assigns.current_admin
    email_changeset = Administration.change_admin_email(admin)
    password_changeset = Administration.change_admin_password(admin)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, admin.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "admin" => admin_params} = params

    email_form =
      socket.assigns.current_admin
      |> Administration.change_admin_email(admin_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "admin" => admin_params} = params
    admin = socket.assigns.current_admin

    case Administration.apply_admin_email(admin, password, admin_params) do
      {:ok, applied_admin} ->
        Administration.deliver_admin_update_email_instructions(
          applied_admin,
          admin.email,
          &url(~p"/admins/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "admin" => admin_params} = params

    password_form =
      socket.assigns.current_admin
      |> Administration.change_admin_password(admin_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "admin" => admin_params} = params
    admin = socket.assigns.current_admin

    case Administration.update_admin_password(admin, password, admin_params) do
      {:ok, admin} ->
        password_form =
          admin
          |> Administration.change_admin_password(admin_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
