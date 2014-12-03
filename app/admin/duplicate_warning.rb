ActiveAdmin.register DuplicateWarning do

  menu priority: 8
  menu parent: 'Items'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  controller do
    def create
      flash[:alert] = 'cats yo'
      redirect_to root_path
    end


    def scoped_collection
      super.includes :duplicate_warnings
    end

  end




end
