class PostsController < InheritedResources::Base
  
  actions :index, :show, :new, :edit, :create, :update, :destroy
  respond_to :html, :js, :xml, :json

  ##############################################################################
  # begin authorizer
  ##############################################################################

  # own created objects so you can access them after creation
  after_filter :own_created_object, :only => :create
  # authorize entire controller
  before_filter :authorize, :only => [ :show, :edit, :update, :destroy ]

  ##############################################################################
  # end authorizer
  ##############################################################################

  protected
    
    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @posts ||= end_of_association_chain.paginate(paginate_options)
    end
        
end