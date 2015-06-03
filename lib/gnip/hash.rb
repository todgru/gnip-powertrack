# Patch Hash to enable symbolization of keys, borrowed from the Rails project
# https://github.com/rails/rails/blob/master/activesupport/src/active_support/core_ext/hash/keys.rb

class Hash
  def transform_keys
    result = {}
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end

  def symbolize_keys
    transform_keys{ |key| key.to_sym rescue key }
  end
end