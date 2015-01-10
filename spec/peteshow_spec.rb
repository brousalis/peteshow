require 'spec_helper'

describe Peteshow do
  let(:peteshow_menu) { find('#peteshow') }

  before do
    visit '/'
  end

  it 'is included on the page' do
    expect(peteshow_menu).to be_visible
  end
end
