module MiniCamel

  class Dto < OpenStruct

    delegate :to_json, :as_json, :to_hash, :keys, :to_ary, to: :table

    def self.empty
      new
    end

    # ensures that every hash like object is a dto
    def self.build(hash_object)
      hash_object = MultiJson.load(MultiJson.dump(self.new(hash_object)))
      deep_build(hash_object)
    end

    # @private
    def self.deep_build(hash_object)
      case hash_object
      when Hash
        hash_object.each do |k, v|
          hash_object[k] = deep_build(v)
        end
        self.new(hash_object)
      when Array
        hash_object.map{|item| deep_build(item)}
      else
        hash_object
      end
    end

    def initialize(hash = {})
      super
      @table = Hashie::Mash.new(hash)
    end

    def update(data = {})
      modifiable.update(data)
    end

    def [](key)
      fetch(key)
    end

    def fetch(key, default: nil)
      if @table.has_key?(key)
        @table.fetch(key, default)
      else
        return default unless default.nil?
      end
    end

  end
end

