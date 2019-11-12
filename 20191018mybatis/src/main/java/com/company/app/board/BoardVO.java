package com.company.app.board;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(value = {"uploadFilename", "seqList", "msg"})
@Entity // 영속 객체
@Table(name="BOARD")
public class BoardVO {
	//@JsonProperty("글번호") private int seq;
	@Id
	@GeneratedValue
	private int seq; // @Id :primary key
	@Column(nullable = false)
	private String title;
	@Column(updatable = false, length = 30)
	private String writer;
	@Column(name = "contents", length = 2000)
	private String content;
	@Temporal (TemporalType.DATE)
	private Date regDate = new java.util.Date();
	private int cnt;
	// @Transient :테이블에 만들지 않을 컬럼
	@Transient private String uploadFilename; 
	@Transient private String orderby;
	@Transient private int[] seqList;
	@Transient private String msg;
	//private List<MultipartFile> uploadFile; // 1024 파일 업로드용 list로 여러개 받음
	//private String boardType;
}
