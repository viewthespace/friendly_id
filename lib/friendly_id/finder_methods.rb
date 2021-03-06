module FriendlyId
  # These methods will be added to the model's {FriendlyId::Base#relation_class relation_class}.
  module FinderMethods

    protected

    # FriendlyId overrides this method to make it possible to use friendly id's
    # identically to numeric ids in finders.
    #
    # @example
    #  person = Person.find(123)
    #  person = Person.find("joe")
    #
    # @see FriendlyId::ObjectUtils
    def find_one(id)
      # Check if the string is actually an integer, in which case abort - security threat when using Object#find
      return super if (id.unfriendly_id? || id.to_s == id.to_i.to_s)
      where(@klass.friendly_id_config.query_field => id).first or super
    end

    # FriendlyId overrides this method to make it possible to use friendly id's
    # identically to numeric ids in finders.
    #
    # @example
    #  person = Person.exists?(123)
    #  person = Person.exists?("joe")
    #  person = Person.exists?({:name => 'joe'})
    #  person = Person.exists?(['name = ?', 'joe'])
    #
    # @see FriendlyId::ObjectUtils
    def exists?(id = false)
      return super if id.unfriendly_id?
      super @klass.friendly_id_config.query_field => id
    end
  end
end
