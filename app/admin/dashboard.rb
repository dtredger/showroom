ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    # recent items
    columns do
      column do
        panel "Recent Items" do
          ul do
            Item.last(10).map do |item|
              li link_to(item.product_name, admin_item_path(item))
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Admin Users" do
          ul do
            AdminUser.last(10).map do |user|
              li link_to(user.email, admin_admin_user_path(user))
            end
          end
        end
      end
    end

  end
end
