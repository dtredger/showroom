class ItemsManagementController < ApplicationController

	def index
		# params modify the "search"/display conditions

		# (1) Identical Match
		Item.where status = pending & duplicate_warning = Identical
			- Need to include item and match


		# (2) Potential Match
		Item.where status = pending & duplicate_warning != Identical
			- Need to include item, duplicate_warning, and match

		# (3) No Match
		Item.where status = pending & no duplicate_warning
			- This should be the easiest of the three
			- Easy display to the user

	end

end