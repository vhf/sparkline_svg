defmodule SparklineMarkerTest do
  use ExUnit.Case, async: true

  test "to_svg/2 with invalid marker" do
    data_number = [{1, 1}, {2, 2}]
    data_time = [{Time.utc_now(), 1}, {Time.utc_now() |> Time.add(1, :second), 2}]

    assert Sparkline.new(data_number) |> Sparkline.add_marker("b") |> Sparkline.to_svg() ==
             {:error, :invalid_x_type}

    assert Sparkline.new(data_number) |> Sparkline.add_marker({"b", 1}) |> Sparkline.to_svg() ==
             {:error, :invalid_x_type}

    assert Sparkline.new(data_number)
           |> Sparkline.add_marker(DateTime.utc_now())
           |> Sparkline.to_svg() ==
             {:error, :mixed_datapoints_types}

    assert Sparkline.new(data_time) |> Sparkline.add_marker(1) |> Sparkline.to_svg() ==
             {:error, :mixed_datapoints_types}
  end

  test "to_svg/2 with valid marker" do
    data_number = [{1, 1}, {2, 2}]
    data_time = [{Time.utc_now(), 1}, {Time.utc_now() |> Time.add(1, :second), 2}]

    assert Sparkline.new(data_number) |> Sparkline.add_marker(1) |> Sparkline.to_svg() ==
             {:ok,
              ~S'<svg width="100%" height="100%" viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg"><path d="M6.0,0.0V100" fill="none" stroke="red" stroke-width="0.25" /></svg>'}

    assert Sparkline.new(data_number) |> Sparkline.add_marker({1, 2}) |> Sparkline.to_svg() ==
             {:ok,
              ~S'<svg width="100%" height="100%" viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg"><rect x="6.0" y="-0.25" width="188.0" height="100.5" fill="rgba(255, 0, 0, 0.2)" stroke="red" stroke-width="0.25" /></svg>'}

    assert Sparkline.new(data_time)
           |> Sparkline.add_marker(Time.utc_now())
           |> Sparkline.to_svg() ==
             {:ok,
              ~S'<svg width="100%" height="100%" viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg"><path d="M6.0,0.0V100" fill="none" stroke="red" stroke-width="0.25" /></svg>'}
  end

  test "to_svg/2 with multiple markers" do
    assert Sparkline.new([{1, 1}, {2, 2}])
           |> Sparkline.add_marker(1)
           |> Sparkline.add_marker(2)
           |> Sparkline.add_marker({1, 2})
           |> Sparkline.to_svg() ==
             {:ok,
              ~S'<svg width="100%" height="100%" viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg"><path d="M6.0,0.0V100" fill="none" stroke="red" stroke-width="0.25" /><path d="M194.0,0.0V100" fill="none" stroke="red" stroke-width="0.25" /><rect x="6.0" y="-0.25" width="188.0" height="100.5" fill="rgba(255, 0, 0, 0.2)" stroke="red" stroke-width="0.25" /></svg>'}
  end
end
