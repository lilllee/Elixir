defmodule Counter.Server do

  def test() do
    #  def run(number) do
    #    # 타이머 구독
    #    timer_ref = :timer.subscribe(1000, handle_timer(1))
    #    loop(number, timer_ref)
    #  end
    #
    #  def handle_timer(number) do
    #    # 카운터 값 증가
    #    number = Counter.Core.inc(number)
    #
    #    # 타입 정보 없는 메시지 제거
    #    receive do
    #      {:tick, _pid, type} ->
    #        # type 정보 사용
    #        case type do
    #          "t1" -> Counter.Core.inc(number)
    #          "t2" -> Counter.Core.dec(number)
    #        end
    #      {:state, pid} -> send(pid, {:state, number}); number
    #    end
    #  end
    #
    #  def loop(number, timer_ref) do
    #    receive do
    #      {:tick, _pid, type} ->
    #        # type 정보 사용
    #        case type do
    #          "t1" -> Counter.Core.inc(number)
    #          "t2" -> Counter.Core.dec(number)
    #        end
    #        loop(number, timer_ref)
    #      {:state, pid} -> send(pid, {:state, number}); loop(number, timer_ref)
    #    end
    #  end
  end

  def run(number) do
    new_number = listen(number)
    run(new_number)
  end

  def listen(number) do
    receive do
      {:tick, pid, type} ->
        cond do
          type == "inc" -> Counter.Core.inc(number)
          type == "dec" -> Counter.Core.dec(number)
        end
      {:state, pid} -> send pid, {:state, number}; number
    end
  end
end