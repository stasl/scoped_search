require 'spec_helper'

describe ScopedSearch, 'when using DataMapper' do
  
  before(:all) do

    DataMapper.setup(:default, 'sqlite3::memory:')

    class ::Foo
      include DataMapper::Resource

      property :id,        Serial
      property :search,    Text
      property :no_search, Text
      
      scoped_search :on => :search
    end
    
    ::Foo.auto_migrate!
  end
  
  after(:all) do
    Object.send(:remove_const, 'Foo')
  end
  
  before(:each) do
    @record = ::Foo.create(:search => "Testing 123", :no_search => "Testing 456")
  end
  
  it "should find the record using 'testing'" do
    records = ::Foo.search_for('testing')
    records.should include(@record)
  end
  
  it "should find the record using '123'" do
    records = ::Foo.search_for('123')
    records.should include(@record)
  end
  
  it "should not find the record using '456'" do
    records = ::Foo.search_for('456')
    records.should_not include(@record)
  end
  
end
