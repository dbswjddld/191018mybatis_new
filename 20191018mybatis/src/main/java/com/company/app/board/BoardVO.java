package com.company.app.board;

import java.sql.Date;

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
}
