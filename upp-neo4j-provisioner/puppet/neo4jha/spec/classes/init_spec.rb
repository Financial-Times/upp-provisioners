require 'spec_helper'
describe 'neo4jha' do

  context 'with defaults for all parameters' do
    it { should contain_class('neo4jha') }
  end
end
