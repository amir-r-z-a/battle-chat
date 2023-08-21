defmodule VerifyWeb.Live.ChatLive.FormComponent do
  use VerifyWeb, :live_component
  use Phoenix.Component

  # def inspect_form do
  #   IO.inspect(@changed, label: "changed")
  #   IO.inspect @form, label: "form"
  # end

  # def render(assigns) do
  #   ~H"""
  #   <div>
  #       <input type="text" name="message" phx-change= {} />
  #       <button type="button" name="button" phx-click="save" phx-value-ajab={} >Send</button>
  #   </div>
  #   """
  # end




    def render(assigns) do
    ~H"""
    <div>
    <.form for={@form}  phx-submit="save">
    <.input type="text" field={@form[:content]} />
    <button>Save</button>
    </.form>
    </div>
    """
  end



end
