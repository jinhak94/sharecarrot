package com.kh.sharecarrot.config;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

import com.kh.sharecarrot.member.model.service.MemberService;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	private MemberService memberService;
	
	@Autowired
	private DataSource dataSource;
	
	@Bean
	public PersistentTokenRepository tokenRepository() {
		JdbcTokenRepositoryImpl tokenRepository = 
				new JdbcTokenRepositoryImpl();
		tokenRepository.setDataSource(dataSource);
		return tokenRepository;
	}
	
	/**
	 * 클래스레벨에 작성한 @Configuration 하위에서 작동.
	 * 리턴 객체를 빈으로 등록하는 사용.
	 * id : passwordEncoder 메소드 이름
	 */
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	
	/**
	 * WebSecurity 객체를 통해 인증대상에서 제외될 자원을 설정
	 */
	@Override
	public void configure(WebSecurity web) throws Exception {
		//webapp 밑의 resources 자원들을 요청하면 검사하지 않음.
		web.ignoring().antMatchers("/resources/**");
	}

	/**
	 * HttpSecurity 객체를 통해 인증/권한, 로그인/로그아웃 등을 설정
	 */
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
		.antMatchers("/member/**").authenticated() //인증된 사용자만
		.antMatchers("/board/**").hasRole(MemberService.ROLE_USER)  //인증된 사용자만
		.antMatchers("/admin/**").hasRole(MemberService.ROLE_ADMIN)  //인증된 사용자만
		.antMatchers("/").permitAll(); //모두 허용
	
		http.formLogin()
			.loginPage("/member/memberLogin.do")		  // GET /login
			.loginProcessingUrl("/member/memberLogin.do") //POST /login
			.usernameParameter("id")
			.passwordParameter("password")
			.defaultSuccessUrl("/")
			.permitAll();
		
		//remember-me 기능 : session timeout 이상으로 인증을 유지
		http.rememberMe()
			.key("spring-security-app") // application별 고유문자열
			.tokenValiditySeconds(60 * 60 * 24 * 14) // 14일은 기본값
			.tokenRepository(tokenRepository()); //database관련정보 제공
		
		
		// 로그아웃은 반드시 POST 요청으로 처리해야 함
		http.logout()
			.logoutUrl("/member/memberLogout.do") // POST
			.logoutSuccessUrl("/")
			.invalidateHttpSession(true);
		
//		post 요청은 jsp에서 form:form으로 써야함
//		form:form은 csrf 토큰을 발행해야함.
		
		//접근권한 없음 페이지 연결
		http.exceptionHandling()
			.accessDeniedPage("/error/accessDenied.do");
	}

	/**
	 * AuthenticationManagerBuilder객체를 통해
	 * UserDetailsService 구현체 빈, 비밀번호 암호화 빈 등록
	 */
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(memberService)
			.passwordEncoder(passwordEncoder());
	}
}









