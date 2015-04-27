ActiveAdmin.register AdminUser do

  menu priority: 13

  # TODO - possible we want to allow admins to edit themselves in the future
  actions :all, except: [:new, :create, :edit, :update, :destroy]
  config.filters = false

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end


  action_item :add do
    button_to "Test Jobs Notifier", admin_job_notifier_path, method: :post
  end

  action_item :add do
    button_to "Test Error Notifier", admin_error_notifier_path, method: :post
  end

  controller do
    def test_error_notifier
      error_message = "error message test at #{Time.now}"
      AdminMailer.error_notifier(current_admin_user, error_message).deliver_later
      redirect_to admin_admin_users_path, notice: "error message test sent"
    end

    def test_job_notifier
      test_message = "job details test at #{Time.now}"
      AdminMailer.jobs_notifier(current_admin_user, test_message).deliver_later
      redirect_to admin_admin_users_path, notice: "job notice test sent"
    end
  end

end
