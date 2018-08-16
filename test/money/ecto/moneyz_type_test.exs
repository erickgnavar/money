if Code.ensure_compiled?(Ecto.Type) do
  defmodule Money.Ecto.MoneyzTypeTest do
    use ExUnit.Case, async: false
    doctest Money.Ecto.MoneyzType

    alias Money.Ecto.MoneyzType

    setup do
      Application.put_env(:money, :default_currency, :GBP)

      on_exit fn ->
        Application.delete_env(:money, :default_currency)
      end
    end

    test "type/0" do
      assert MoneyzType.type == :moneyz
    end

    test "cast/1 String" do
      assert MoneyzType.cast("1000") == {:ok, Money.new(100000, :GBP)}
      assert MoneyzType.cast("1234.56") == {:ok, Money.new(123456, :GBP)}
      assert MoneyzType.cast("1,234.56") == {:ok, Money.new(123456, :GBP)}
      assert MoneyzType.cast("£1234.56") == {:ok, Money.new(123456, :GBP)}
      assert MoneyzType.cast("£1,234.56") == {:ok, Money.new(123456, :GBP)}
      assert MoneyzType.cast("£ 1234.56") == {:ok, Money.new(123456, :GBP)}
      assert MoneyzType.cast("£ 1,234.56") == {:ok, Money.new(123456, :GBP)}
      assert MoneyzType.cast("£ 1234") == {:ok, Money.new(123400, :GBP)}
      assert MoneyzType.cast("£ 1,234") == {:ok, Money.new(123400, :GBP)}
    end

    test "cast/1 integer" do
      assert MoneyzType.cast(1000) == {:ok, Money.new(1000, :GBP)}
    end

    test "cast/1 Money" do
      assert MoneyzType.cast(Money.new(1000)) == {:ok, Money.new(1000, :GBP)}
    end

    test "cast/1 Map" do
      assert MoneyzType.cast(%{
               "amount"=> 1000,
               "currency"=>"EUR"
             }) == {:ok, Money.new(1000, :EUR)}
      assert MoneyzType.cast(%{
               "amount"=> "10.0",
               "currency"=>"EUR"
             }) == {:ok, Money.new(1000, :EUR)}
    end

    test "cast/1 other" do
      assert MoneyzType.cast([]) == :error
    end

    test "load/1 integer fails" do
      assert MoneyzType.load({Decimal.new(1000.0), "GBP"}) == {:ok, Money.new(1000, :GBP)}
    end

    test "load/1 moneyz with wrong decimal" do
      assert_raise FunctionClauseError, fn ->
        MoneyzType.load({Decimal.new(1000.1232), "GBP"})
      end
    end

    test "load/1 moneyz" do
      assert MoneyzType.load({Decimal.new(1000.0), "GBP"}) == {:ok, Money.new(1000, :GBP)}
    end

    test "dump/1 integer" do
      assert MoneyzType.dump(1000) == {:ok, {1000, "GBP"}}
    end

    test "dmmp/1 Money" do
      assert MoneyzType.dump(Money.new(1000, :GBP)) == {:ok, {1000, "GBP"}}
    end

    test "dump/1 other" do
      assert MoneyzType.dump([]) == :error
    end
  end
end
