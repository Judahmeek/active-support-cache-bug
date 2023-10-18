# frozen_string_literal: true
require "rails"

require "rails/test_help"
require_relative "../spec_helper"

class TestingCache
  def call; end
end

describe "wat", :caching do
  it "fetches the value from the cache if the value is a Hash" do
    create_component_code = instance_double(TestingCache, call: { component_html: "<div>Something</div>" })

    result1 = Rails.cache.fetch("the_cache_key-7.1") do
      create_component_code.call
    end

    expect(create_component_code).to have_received(:call).once
    puts "XYZYX"
    p cache_data.values.first.value
    expect(cache_data.values.first.value[:component_html]).to eq({})
  end
end
