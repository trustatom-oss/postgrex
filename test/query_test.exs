defmodule QueryTest do
  use ExUnit.Case, async: true
  import Postgrex.TestHelper

  setup do
    { :ok, pid } = Postgrex.connect("localhost", "postgres", "postgres", "postgrex_test", [], [])
    { :ok, [pid: pid] }
  end

  teardown context do
    :ok = Postgrex.disconnect(context[:pid])
  end

  test "decode basic types", context do
    assert [{ nil }] = query("SELECT NULL")
    assert [{ true, false }] = query("SELECT true, false")
    assert [{ "e" }] = query("SELECT 'e'::char")
    assert [{ "ẽ" }] = query("SELECT 'ẽ'::char")
    assert [{ 42 }] = query("SELECT 42")
    assert [{ 42.0 }] = query("SELECT 42::float")
    assert [{ "ẽric" }] = query("SELECT 'ẽric'")
    assert [{ "ẽric" }] = query("SELECT 'ẽric'::varchar")
    assert [{ << 1, 2, 3 >> }] = query("SELECT '\\001\\002\\003'::bytea")
  end

  test "decode arrays", context do
    assert [{ [] }] = query("SELECT ARRAY[]::integer[]")
    assert [{ [1] }] = query("SELECT ARRAY[1]")
    assert [{ [1,2] }] = query("SELECT ARRAY[1,2]")
    assert [{ [[0],[1]] }] = query("SELECT ARRAY[[0],[1]]")
    assert [{ [[0]] }] = query("SELECT ARRAY[ARRAY[0]]")
  end

  test "decode time", context do
    assert [{ {0,0,0} }] = query("SELECT time '00:00:00'")
    assert [{ {1,2,3} }] = query("SELECT time '01:02:03'")
    assert [{ {23,59,59} }] = query("SELECT time '23:59:59'")
    assert [{ {4,5,6} }] = query("SELECT time '04:05:06 PST'")
  end

  test "decode date", context do
    assert [{ {1,1,1} }] = query("SELECT date '0001-01-01'")
    assert [{ {1,2,3} }] = query("SELECT date '0001-02-03'")
    assert [{ {2013,9,23} }] = query("SELECT date '2013-09-23'")
  end

  test "decode timestamp", context do
    assert [{ {{1,1,1},{0,0,0}} }] = query("SELECT timestamp '0001-01-01 00:00:00'")
    assert [{ {{2013,9,23},{14,4,37}} }] = query("SELECT timestamp '2013-09-23 14:04:37'")
    assert [{ {{2013,9,23},{14,4,37}} }] = query("SELECT timestamp '2013-09-23 14:04:37 PST'")
  end

  test "decode interval", context do
    assert [{ {0,0,0} }] = query("SELECT interval '0'")
    assert [{ {0,100,0} }] = query("SELECT interval '100 days'")
    assert [{ {180000,0,0} }] = query("SELECT interval '50 hours'")
    assert [{ {1,0,0} }] = query("SELECT interval '1 second'")
    assert [{ {10920,40,14} }] = query("SELECT interval '1 year 2 months 40 days 3 hours 2 minutes'")
  end

  test "encode basic types", context do
    assert [{ nil, nil }] = query("SELECT $1::text, $2::int", [nil, nil])
    assert [{ true, false }] = query("SELECT $1::bool, $2::bool", [true, false])
    assert [{ "ẽ" }] = query("SELECT $1::char", ["ẽ"])
    assert [{ 42 }] = query("SELECT $1::int", [42])
    assert [{ 42.0, 43.0 }] = query("SELECT $1::float, $2::float", [42, 43.0])
    assert [{ "ẽric" }] = query("SELECT $1::varchar", ["ẽric"])
    assert [{ << 1, 2, 3 >> }] = query("SELECT $1::bytea", [<< 1, 2, 3 >>])
  end

  test "encode date", context do
    assert [{ {1,1,1} }] = query("SELECT $1::date", [{1,1,1}])
    assert [{ {1,2,3} }] = query("SELECT $1::date", [{1,2,3}])
    assert [{ {2013,9,23} }] = query("SELECT $1::date", [{2013,9,23}])
  end

  test "encode time", context do
    assert [{ {0,0,0} }] = query("SELECT $1::time", [{0,0,0}])
    assert [{ {1,2,3} }] = query("SELECT $1::time", [{1,2,3}])
    assert [{ {23,59,59} }] = query("SELECT $1::time", [{23,59,59}])
    assert [{ {4,5,6} }] = query("SELECT $1::time", [{4,5,6}])
  end

  test "encode timestamp", context do
    assert [{ {{1,1,1},{0,0,0}} }] =
      query("SELECT $1::timestamp", [{{1,1,1},{0,0,0}}])
    assert [{ {{2013,9,23},{14,4,37}} }] =
      query("SELECT $1::timestamp", [{{2013,9,23},{14,4,37}}])
    assert [{ {{2013,9,23},{14,4,37}} }] =
      query("SELECT $1::timestamp", [{{2013,9,23},{14,4,37}}])
  end

  test "encode interval", context do
    assert [{ {0,0,0} }] =
      query("SELECT $1::interval", [{0,0,0}])
    assert [{ {0,100,0} }] =
      query("SELECT $1::interval", [{0,100,0}])
    assert [{ {180000,0,0} }] =
      query("SELECT $1::interval", [{180000,0,0}])
    assert [{ {1,0,0} }] =
      query("SELECT $1::interval", [{1,0,0}])
    assert [{ {10920,40,14} }] =
      query("SELECT $1::interval", [{10920,40,14}])
  end

  test "encode arrays", context do
    assert [{ [] }] = query("SELECT $1::integer[]", [[]])
    assert [{ [1] }] = query("SELECT $1::integer[]", [[1]])
    assert [{ [1,2] }] = query("SELECT $1::integer[]", [[1,2]])
    assert [{ [[0],[1]] }] = query("SELECT $1::integer[]", [[[0],[1]]])
    assert [{ [[0]] }] = query("SELECT $1::integer[]", [[[0]]])
  end

  test "fail on encode arrays", context do
    assert Postgrex.Error[] =
           query("SELECT $1::integer[]", [[[1], [1,2]]])
    assert [{42}] = query("SELECT 42")
  end

  test "fail on encode wrong value", context do
    assert Postgrex.Error[] =
           query("SELECT $1::integer", ["123"])
    assert Postgrex.Error[] =
           query("SELECT $1::text", [4.0])
    assert [{42}] = query("SELECT 42")
  end

  test "non data statement", context do
    assert :ok = query("BEGIN")
    assert :ok = query("COMMIT")
  end
end
