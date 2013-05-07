require 'spec_helper'

describe 'mkdir_p' do
  it 'returns array of all intermediate paths in the given path' do
    should run.with_params('/srv/apps/security')
  end
end
