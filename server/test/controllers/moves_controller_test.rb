require 'test_helper'

class MovesControllerTest < ActionDispatch::IntegrationTest
  test "adds words and returns state" do
    create :placement, x: 13, y: 17, value: "t"
    placement_data = { x: 13, y: 16, value: "a" }
    post "/move", params: { placements: [ placement_data ] }, as: :json
    assert_response :success
    assert_equal Placement.last.value, "a"
    assert_equal Placement.last.x, 13
    assert_equal Placement.last.y, 16
    assert_includes response.body, placement_data.to_json
  end

  test "Verifies as word" do
    placement_a = { x: 13, y: 15, value: "a"  }
    placement_c = { x: 13, y: 16, value: "c"  }
    placement_x = { x: 13, y: 17, value: "x"  }
    post "/move", params: { placements: [ placement_a, placement_c, placement_x ] }, as: :json
    assert_empty Placement.where value: "x"
    assert_includes response.body, "acx is not valid"
  end

  test "Checks for adjacency" do
    placement_a = { x: 14, y: 15, value: "c"  }
    placement_c = { x: 14, y: 16, value: "a"  }
    placement_x = { x: 14, y: 17, value: "r"  }
    post "/move", params: { placements: [ placement_a, placement_c, placement_x ] }, as: :json
    assert_empty Placement.where value: "r"
    assert_includes response.body, "Not touching"
  end

  test "Checks for continuity" do
    placement_c = { x: 14, y: 13, value: "c"  }
    create :placement, x: 15, y: 13, value: "a"
    create :placement, x: 16, y: 13, value: "d"
    placement_a = { x: 14, y: 16, value: "a"  }
    placement_r = { x: 14, y: 17, value: "r"  }
    create :placement, x: 18, y: 18, value: "t"
    post "/move", params: { placements: [ placement_c, placement_a, placement_r ] }, as: :json
    assert_empty Placement.where value: "r"
    assert_includes response.body, "Gappy"
  end
end
