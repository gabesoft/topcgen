package topc.test.dynamic;

import junit.framework.*;
import org.junit.Test;
import static org.junit.Assert.*;
import topc.dynamic.*;

public class KiloManXTest {
  double DELTA = 1.0e-09;
  KiloManX kilomanx = new KiloManX();

  @Test
  public void case1() {
    String[] damageChart = { "070", "500", "140" };
    int[] bossHealth = { 150, 150, 150 };
    assertEquals(218.0, kilomanx.leastShots(damageChart, bossHealth), DELTA * 218.0);
  }

  @Test
  public void case2() {
    String[] damageChart = { "1542", "7935", "1139", "8882" };
    int[] bossHealth = { 150, 150, 150, 150 };
    assertEquals(205.0, kilomanx.leastShots(damageChart, bossHealth), DELTA * 205.0);
  }

  @Test
  public void case3() {
    String[] damageChart = { "07", "40" };
    int[] bossHealth = { 150, 10 };
    assertEquals(48.0, kilomanx.leastShots(damageChart, bossHealth), DELTA * 48.0);
  }

}
