class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :admin?, :recepcionista?, :mecanico?

  private
    def current_user
      Current.user
    end

    def admin?
      current_user&.admin?
    end

    def recepcionista?
      current_user&.recepcionista?
    end

    def mecanico?
      current_user&.mecanico?
    end

    def require_admin
      redirect_to root_path, alert: "No tiene permisos para realizar esta acción." unless admin?
    end

def require_admin_or_recepcionista
      return if admin? || recepcionista?
      redirect_to root_path, alert: "No tiene permisos para realizar esta acci��n."
    end

    def destroy_with_errors(record, redirect_path)
      if record.destroy
        redirect_to redirect_path, notice: "Registro eliminado.", status: :see_other
      else
        redirect_to redirect_path,
                    alert: record.errors.full_messages.join(", "),
                    status: :see_other
      end
    rescue ActiveRecord::RecordNotDestroyed
      redirect_to redirect_path,
                  alert: record.errors.full_messages.join(", "),
                  status: :see_other
    end
end
