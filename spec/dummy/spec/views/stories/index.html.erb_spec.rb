require 'spec_helper'

describe "stories/index" do
  before(:each) do
    assign(:stories, [
      stub_model(Story,
        :title => "Title"
      ),
      stub_model(Story,
        :title => "Title"
      )
    ])
  end

  it "renders a list of stories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
