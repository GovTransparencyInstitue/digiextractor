package com.precognox.digiwhist.mapper;

import com.precognox.digiwhist.mapper.util.Util;
import org.junit.Assert;
import org.junit.Test;


public class UtilTest {

    @Test
    public void test() {
        Assert.assertNotNull(Util.parseDate("26/05/2016"));

    }
}