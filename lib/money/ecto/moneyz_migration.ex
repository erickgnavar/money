defmodule Money.Ecto.MoneyzMigration do
  defmacro __using__(_) do
    quote do
      use Ecto.Migration

      def up do
        execute "CREATE TYPE moneyz AS(amount INTEGER, currency VARCHAR);"
      end

      def down do
        execute "DROP TYPE moneyz"
      end
    end
  end
end
