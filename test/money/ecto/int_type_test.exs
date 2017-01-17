if Code.ensure_compiled?(Ecto.Type) do
  defmodule Money.Ecto.TypeTest do
    use ExUnit.Case, async: false
    doctest Money.Ecto.IntType

    alias Money.Ecto.IntType

    setup do
      Application.put_env(:money, :default_currency, :GBP)

      on_exit fn ->
        Application.delete_env(:money, :default_currency)
      end
    end

    test "type/0" do
      assert IntType.type == :integer
    end

    test "cast/1 String" do
      assert IntType.cast("1000") == {:ok, Money.new(100000, :GBP)}
      assert IntType.cast("1234.56") == {:ok, Money.new(123456, :GBP)}
      assert IntType.cast("1,234.56") == {:ok, Money.new(123456, :GBP)}
      assert IntType.cast("£1234.56") == {:ok, Money.new(123456, :GBP)}
      assert IntType.cast("£1,234.56") == {:ok, Money.new(123456, :GBP)}
      assert IntType.cast("£ 1234.56") == {:ok, Money.new(123456, :GBP)}
      assert IntType.cast("£ 1,234.56") == {:ok, Money.new(123456, :GBP)}
      assert IntType.cast("£ 1234") == {:ok, Money.new(123400, :GBP)}
      assert IntType.cast("£ 1,234") == {:ok, Money.new(123400, :GBP)}
    end

    test "cast/1 integer" do
      assert IntType.cast(1000) == {:ok, Money.new(1000, :GBP)}
    end

    test "cast/1 Money" do
      assert IntType.cast(Money.new(1000)) == {:ok, Money.new(1000, :GBP)}
    end

    test "cast/1 other" do
      assert IntType.cast([]) == :error
    end

    test "load/1 integer" do
      assert IntType.load(1000) == {:ok, Money.new(1000, :GBP)}
    end

    test "dump/1 integer" do
      assert IntType.dump(1000) == {:ok, 1000}
    end

    test "dmmp/1 Money" do
      assert IntType.dump(Money.new(1000, :GBP)) == {:ok, 1000}
    end

    test "dump/1 other" do
      assert IntType.dump([]) == :error
    end
  end
end
