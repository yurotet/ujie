package air.com.miutour.guidesys.model;

public class Account {

    public String userId;
    public String token;
    public String username;
    public String password;
    public String imgUrl;
    public String nonce;
    public long expired;
    public long loginTime;
    @Override
    public String toString() {
        return "Account [userId=" + userId + ", token=" + token + ", username=" + username + ", password=" + password + ", imgUrl=" + imgUrl + ", nonce=" + nonce + ", expired=" + expired + ", loginTime=" + loginTime + "]";
    }
    
}
