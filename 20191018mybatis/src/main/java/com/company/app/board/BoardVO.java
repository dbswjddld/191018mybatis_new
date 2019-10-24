package com.company.app.board;

import java.sql.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
@JsonIgnoreProperties(value = {"uploadFilename", "seqList", "msg"})
public class BoardVO {
	@JsonProperty("글번호") private int seq;
	private String title;
	private String writer;
	private String content;
	private Date regDate;
	private int cnt;
	private String uploadFilename;
	private String orderby;
	private int[] seqList;
	private String msg;
	//private List<MultipartFile> uploadFile; // 1024 파일 업로드용 list로 여러개 받음
}
