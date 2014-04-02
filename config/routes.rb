Rails.application.routes.draw do
  resources :languages
  resource :session do
    match 'change_language/:id' => 'sessions#change_language', :as => :change_language
  end
  namespace :admin do
    resources :alt_spelling_systems, :association_notes, :blurbs, :feature_name_types, :feature_relation_types,
      :feature_types, :geo_code_types, :importation_tasks, :languages, :note_titles, :orthographic_systems, :perspectives,
      :phonetic_systems, :users, :writing_systems, :xml_documents, :views
    match 'openid_new' => 'users#openid_new'
    match 'openid_create' => 'users#create', :via => :post
    root :to => 'default#index'
    resources :citations do
      resources :pages
    end
    resources :descriptions do
      resources :citations
      resources :notes do
        get :add_author, :on => :collection
      end
      resources :time_units do
        get :new_form, :on => :collection
      end
    end
    resources :feature_geo_codes do
      resources :citations
      resources :notes do
        get :add_author, :on => :collection
      end
      resources :time_units do
        get :new_form, :on => :collection
      end
    end
    resources :feature_names do
      resources :citations, :feature_name_relations
      get :locate_for_relation, :on => :member
      post :set_priorities, :on => :collection
      resources :notes do
        get :add_author, :on => :collection
      end
      resources :time_units do
        get :new_form, :on => :collection
      end
    end
    resources :feature_name_relations do
      resources :citations
      resources :notes do
        get :add_author, :on => :collection
      end
    end
    resources :feature_relations do
      resources :citations
      resources :notes do
        get :add_author, :on => :collection
      end
      resources :time_units do
        get :new_form, :on => :collection
      end
    end
    resources :features do
      member do
        get :set_primary_description
        get :locate_for_relation
        post :clone
      end
      collection do
        match 'prioritize_feature_names/:id' => 'feature_names#prioritize', :as => :prioritize_feature_names
      end
      resources :captions, :citations, :feature_geo_codes, :feature_names, :feature_relations, :illustrations, :summaries
      resources :association_notes do
        get :add_author, :on => :collection
      end
      resources :descriptions do
        get :add_author, :on => :collection
      end
      resources :time_units do
        get :new_form, :on => :collection
      end
    end
    resources :feature_pids do
      get :available, :on => :collection
    end
    resources :notes do
      get :add_author, :on => :collection
    end
    resources :time_units do
      resources :notes do
        get :add_author, :on => :collection
      end
    end
  end
  resources :features do
    resources :captions, :only => [:index, :show]
    resources :summaries, :only => [:index, :show]
    resources :association_notes
    resources :descriptions do
      member do
        get :expand
        get :show
        get :contract
      end
    end
    member do
      get :all
      get :expanded
      get :children
      get :contracted
      get :descendants
      get :iframe
      get :list
      get :nested
      get :fancy_nested
      get :node_tree_expanded
      get :related
      get :related_list
    end
    collection do
      get :all
      get :characteristics_list
      get :list
      get :fancy_nested
      get :nested
      post :search
      get :search
      match 'by_fid/:fids.:format' => 'features#by_fid'
      match 'by_old_pid/:old_pids' => 'features#by_old_pid'
      match 'by_geo_code/:geo_code.:format' => 'features#by_geo_code'
      match 'by_name/:query.:format' => 'features#by_name', :query => /.*?/
      match 'fids_by_name/:query.:format' => 'features#fids_by_name', :query => /.*?/
      match 'gis_resources/:fids.:format' => 'features#gis_resources'
      post :set_session_variables
    end
    match 'by_topic/:id.:format' => 'topics#feature_descendants'
  end
  resources :description do
    resources :notes, :citations
  end
  resources :feature_geo_codes do
    resources :notes, :citations
  end
  resources :feature_names do
    resources :notes, :citations
  end
  resources :feature_name_relations do
    resources :notes, :citations
  end
  resources :feature_relations do
    resources :notes, :citations
  end
  resources :media, :only => 'show', :path => 'media_objects'
  resources :time_units do
    resources :notes, :citations
  end
  resources :topics, :only => 'show'
  root :to => 'features#index'
  # match ':controller(/:action(/:id(.:format)))'
end