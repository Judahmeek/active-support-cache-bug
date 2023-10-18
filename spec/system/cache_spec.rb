# frozen_string_literal: true
require "rails"

require "rails/test_help"
require_relative "../spec_helper"

RSpec.configure do |config|
  config.before(:each, :caching) do
    cache_store = ActiveSupport::Cache::MemoryStore.new
    allow(controller).to receive(:cache_store).and_return(cache_store) if defined?(controller) && controller
    allow(::Rails).to receive(:cache).and_return(cache_store)
    Rails.cache.clear
  end

  config.around(:each, :caching) do |example|
    caching = ActionController::Base.perform_caching
    ActionController::Base.perform_caching = true
    example.run
    ActionController::Base.perform_caching = caching
  end
end

describe "wat", :caching do
  it "fetches the value from the cache if the value is a Hash" do
    hash = { key: "value" }

    result1 = Rails.cache.fetch("the_cache_key-7.1") do
      hash
    end

    expect(Rails.cache.instance_variable_get(:@data).values.first.value).to eq(hash)
    expect{Rails.cache.instance_variable_get(:@data).values.first.value[:key]}.not_to raise_error(TypeError,
    "no implicit conversion of Symbol into Integer")
  end
end
