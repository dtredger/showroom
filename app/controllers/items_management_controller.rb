class ItemsManagementController < ApplicationController

	def index
		# store_name
		@items = Item.where(state: 0)
		if params[:match_status]
			if params[:match_status] == 'A'
				# no match
				# http://stackoverflow.com/questions/5319400/want-to-find-records-with-no-associated-records-in-rails-3
				@items = Item.where(state: 0).where(store_name: params[:store_name]).where('id NOT IN (SELECT DISTINCT(pending_item_id) FROM duplicate_warnings)')
			elsif params[:match_status] == 'B'
				# Items with potential matches AND no duplicate matches
				# SQL Query:
				# select distinct items.id from items join duplicate_warnings on items.id = duplicate_warnings.pending_item_id where match_score = 2 and items.id not in (select items.id, duplicate_warnings.match_score from items, duplicate_warnings where items.id = duplicate_warnings.pending_item_id and duplicate_warnings.match_score = 3)
				#
				# Eager loading with raw SQL query may be problematic.
				@items = Item.find_by_sql('select distinct items.id from items join duplicate_warnings on items.id = duplicate_warnings.pending_item_id where match_score = 2 and items.id not in (select items.id from items join duplicate_warnings on items.id = duplicate_warnings.pending_item_id where duplicate_warnings.match_score = 3)')
			elsif params[:match_status] == 'C'
				# identical match
				# ADD STORE NAME BACK TO QUERY
				#
				@items = Item.where(state: 0).joins(:duplicate_warnings).where(duplicate_warnings: { match_score: 3}).includes(:matches).uniq
			end
		end
	end

  def edit_multiple
    @items = Item.find(params[:item_ids])
  end

  def update_multiple
    @items = Item.update(params[:items].keys, params[:items].values)
    @items.reject { |i| i.errors.empty? }
    if @items.empty?
      redirect_to :root
    else
      render "index"
    end
  end

  # private

  # def handle_search

  # end
end