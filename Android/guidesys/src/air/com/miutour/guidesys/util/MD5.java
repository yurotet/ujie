package air.com.miutour.guidesys.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import android.os.DropBoxManager.Entry;
import android.text.TextUtils;

public class MD5 {
    private static final String algorithm = "MD5";

    protected static char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e',
            'f' };
    protected static MessageDigest messagedigest = null;
    static {
        try {
            messagedigest = MessageDigest.getInstance("MD5");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static byte[] digest2Bytes(byte[] bytes) {
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("MD5");
        } catch (Exception localNoSuchAlgorithmException) {
        }
        return md.digest(bytes);
    }

    public static String digest2Str(byte[] bytes) {
        return CByte.bytes2Hex(digest2Bytes(bytes));
    }

    public static String digest2Str(String str) {
        if (TextUtils.isEmpty(str)) {
            return "";
        }
        return digest2Str(str.getBytes());
    }

    private static String bufferToHex(byte bytes[]) {
        return bufferToHex(bytes, 0, bytes.length);
    }

    private static String bufferToHex(byte bytes[], int m, int n) {
        StringBuffer stringbuffer = new StringBuffer(2 * n);
        int k = m + n;
        for (int l = m; l < k; l++) {
            appendHexPair(bytes[l], stringbuffer);
        }
        return stringbuffer.toString();
    }

    private static void appendHexPair(byte bt, StringBuffer stringbuffer) {
        char c0 = hexDigits[(bt & 0xf0) >> 4];
        char c1 = hexDigits[bt & 0xf];
        stringbuffer.append(c0);
        stringbuffer.append(c1);
    }

    public static String getFileMD5String(File file) throws IOException {

        InputStream fis;
        fis = new FileInputStream(file);
        byte[] buffer = new byte[1024];
        int numRead = 0;
        while ((numRead = fis.read(buffer)) > 0) {
            messagedigest.update(buffer, 0, numRead);
        }
        fis.close();
        return bufferToHex(messagedigest.digest());
    }
    
    
    
    /**
     * 签名生成算法
     * @param HashMap<String,String> params 请求参数集，所有参数必须已转换为字符串类型
     * @param String secret 签名密钥
     * @return 签名
     * @throws IOException
     */
    public static String getSignature(Map<String,String> params, String secret) throws IOException
    {
        // 先将参数以其参数名的字典序升序进行排序
        Map<String, String> sortedParams = new TreeMap<String, String>(params);
        Set<java.util.Map.Entry<String, String>> entrys = sortedParams.entrySet();
     
        
        // 遍历排序后的字典，将所有参数按"key=value"格式拼接在一起
        StringBuilder basestring = new StringBuilder();
        for (java.util.Map.Entry<String, String> param : entrys) {
            basestring.append(param.getKey()).append("=").append(param.getValue());
        }
        basestring.append(secret);
     
        // 使用MD5对待签名串求签
        byte[] bytes = null;
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            bytes = md5.digest(basestring.toString().getBytes("UTF-8"));
        } catch (GeneralSecurityException ex) {
            throw new IOException(ex);
        }
     
        // 将MD5输出的二进制结果转换为小写的十六进制
        StringBuilder sign = new StringBuilder();
        for (int i = 0; i < bytes.length; i++) {
            String hex = Integer.toHexString(bytes[i] & 0xFF);
            if (hex.length() == 1) {
                sign.append("0");
            }
            sign.append(hex);
        }
        return sign.toString();
    }
    
    
    
    public static String getSignatureByValue(Map<String,String> params, String secret) throws IOException
    {
        // 先将参数以其参数名的字典序升序进行排序
        Map<String, String> sortedParams = new TreeMap<String, String>(params);
        Map<String, String> resultMap = sortMapByValue(sortedParams);
        Set<java.util.Map.Entry<String, String>> entrys = resultMap.entrySet();
     
        
        // 遍历排序后的字典，将所有参数按"key=value"格式拼接在一起
        StringBuilder basestring = new StringBuilder();
        for (java.util.Map.Entry<String, String> param : entrys) {
            basestring.append(param.getValue());
        }
        basestring.append(secret);
     
        // 使用MD5对待签名串求签
        byte[] bytes = null;
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            bytes = md5.digest(basestring.toString().getBytes("UTF-8"));
        } catch (GeneralSecurityException ex) {
            throw new IOException(ex);
        }
     
        // 将MD5输出的二进制结果转换为小写的十六进制
        StringBuilder sign = new StringBuilder();
        for (int i = 0; i < bytes.length; i++) {
            String hex = Integer.toHexString(bytes[i] & 0xFF);
            if (hex.length() == 1) {
                sign.append("0");
            }
            sign.append(hex);
        }
        return sign.toString();
    }

        public void main(String[] args) {
            Map<String, String> map = new TreeMap<String, String>();
            map.put("KFC", "kfc");
            map.put("WNBA", "wnba");
            map.put("NBA", "nba");
            map.put("CBA", "cba");
            Map<String, String> resultMap = sortMapByValue(map); //按Value进行排序
            for (Map.Entry<String, String> entry : resultMap.entrySet()) {
                System.out.println(entry.getKey() + " " + entry.getValue());
            }
        }
        
        /**
         * 使用 Map按value进行排序
         * @param map
         * @return
         */
        public static Map<String, String> sortMapByValue(Map<String, String> map) {
            if (map == null || map.isEmpty()) {
                return null;
            }
            Map<String, String> sortedMap = new LinkedHashMap<String, String>();
            List<Map.Entry<String, String>> entryList = new ArrayList<Map.Entry<String, String>>(map.entrySet());
            Collections.sort(entryList, new MapValueComparator());
            Iterator<Map.Entry<String, String>> iter = entryList.iterator();
            Map.Entry<String, String> tmpEntry = null;
            while (iter.hasNext()) {
                tmpEntry = iter.next();
                sortedMap.put(tmpEntry.getKey(), tmpEntry.getValue());
            }
            return sortedMap;
        }

    //比较器类
    public static class MapValueComparator implements Comparator<Map.Entry<String, String>> {

        @Override
        public int compare(java.util.Map.Entry<String, String> lhs, java.util.Map.Entry<String, String> rhs) {
            // TODO Auto-generated method stub
            return lhs.getValue().compareTo(rhs.getValue());
        }
    }
    
}
