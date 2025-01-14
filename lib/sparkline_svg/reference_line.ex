defmodule SparklineSvg.ReferenceLine do
  @moduledoc false

  alias SparklineSvg.ReferenceLine

  @type ref_line_opts :: %{
          width: String.t(),
          color: String.t(),
          dasharray: String.t(),
          class: nil | String.t()
        }

  @type t :: %ReferenceLine{
          type: SparklineSvg.ref_line(),
          value: nil | number(),
          position: nil | number(),
          options: ref_line_opts()
        }
  @enforce_keys [:type, :value, :position, :options]
  defstruct [:type, :value, :position, :options]

  @valid_types [:max, :min, :avg, :median]
  @default_opts [width: 0.25, color: "rgba(0, 0, 0, 0.5)", dasharray: "", class: nil]

  @spec new(SparklineSvg.ref_line()) :: ReferenceLine.t()
  @spec new(SparklineSvg.ref_line(), SparklineSvg.ref_line_options()) :: ReferenceLine.t()
  def new(type, options \\ []) do
    options =
      @default_opts
      |> Keyword.merge(options)
      |> Map.new()

    %ReferenceLine{type: type, value: nil, position: nil, options: options}
  end

  @spec clean(SparklineSvg.ref_lines()) :: {:ok, SparklineSvg.ref_lines()} | {:error, atom()}
  def clean(ref_lines) do
    keys = Map.keys(ref_lines)

    cond do
      keys == [] -> {:ok, ref_lines}
      Enum.all?(keys, &Enum.member?(@valid_types, &1)) -> {:ok, ref_lines}
      true -> {:error, :invalid_ref_line_type}
    end
  end
end
