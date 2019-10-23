package com.company.app.board;

import java.util.Arrays;

public class BoardSearchVO extends BoardVO{
	private String uploadFilename;
	private String orderby;
	private int[] seqList;
	private String msg;
	public String getUploadFilename() {
		return uploadFilename;
	}
	public void setUploadFilename(String uploadFilename) {
		this.uploadFilename = uploadFilename;
	}
	public String getOrderby() {
		return orderby;
	}
	public void setOrderby(String orderby) {
		this.orderby = orderby;
	}
	public int[] getSeqList() {
		return seqList;
	}
	public void setSeqList(int[] seqList) {
		this.seqList = seqList;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	@Override
	public String toString() {
		return "BoardSearchVO [uploadFilename=" + uploadFilename + ", orderby=" + orderby + ", seqList="
				+ Arrays.toString(seqList) + ", msg=" + msg + "]";
	}
	
	
	
}
