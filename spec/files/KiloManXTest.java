package topc.test.dynamic;

import junit.framework.*;
import static org.junit.Assert.*;
import org.junit.Test;

import topc.dynamic.*;

public class KiloManXTest {
  KiloManX kilomanx = new KiloManX();

  @Test
  public void case1() {	
    String[] damageChart = {"070","500","140"};
    int[] bossHealth = {150,150,150};
    assertEquals(new int[] { 218 }, kilomanx.leastShots(damageChart, bossHealth));
  }

  @Test
  public void case2() {	
    String[] damageChart = {"1542", "7935", "1139", "8882"};
    int[] bossHealth = {150,150,150,150};
    assertEquals(new int[] { 205 }, kilomanx.leastShots(damageChart, bossHealth));
  }

  @Test
  public void case3() {	
    String[] damageChart = {"07", "40"};
    int[] bossHealth = {150,10};
    assertEquals(new int[] { 48 }, kilomanx.leastShots(damageChart, bossHealth));
  }
}
