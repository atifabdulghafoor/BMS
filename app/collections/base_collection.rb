# frozen_string_literal: true

# Base collection class for filtering relations
class BaseCollection
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  DEFAULT_SORT_BY = 'created_at'
  DEFAULT_SORT = 'desc'

  attr_reader :params

  def initialize(relation, params)
    @relation = relation
    @params = params
  end

  def results
    @results ||= begin
      ensure_filters
      sort_records
      paginate
    end
  end

  private

  def filter
    @relation = yield(@relation)
  end

  def sort_records
    filter do
      @relation.reorder(
        params[:order_by].presence || DEFAULT_SORT_BY => params[:order].presence || DEFAULT_SORT
      )
    end
  end

  def paginate
    @relation.paginate(params[:page] || DEFAULT_PAGE,
                       per_page: params[:per_page] || DEFAULT_PER_PAGE)
  end

  def ensure_filters; end

  def model
    @relation.model
  end
end
